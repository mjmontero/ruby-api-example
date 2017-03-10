

class Api

  resource :users do
  
    # GET method to show all users, authentication needed
    # 1. Use "login" to get the token
    # 2. Use this token in the Authorization key in header
    desc 'Get users', {
      headers: {
        "Authorization" => {
          description: "Validates your identity - Use JWT. Example: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9",
          required: true
        },
      }
    }    
    params do
      includes :basic_search
    end
    get do
      users = SEQUEL_DB[:users].all
      {
        data: users
      }
    end

    # POST method to create one user, authentication needed
    # 1. Use "login" to get the token
    # 2. Use this token in the Authorization key in header
    desc 'Create one user', {
      failure: [{ code: 401, message: 'Unauthorized' }], 
      headers: {
        "Authorization" => {
          description: "Validates your identity - Use JWT. Example: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9",
          required: true
        },
      }
    }  
    params do
      requires :first_name, type: String, desc: 'First Name'
      requires :last_name, type: String, desc: 'Last Name'
      requires :email, type: String, desc: 'Email'
      requires :password, type: String, desc: 'Password'
      optional :born_on, type: Date, desc: 'Date of birth'
    end
    post do
      # Creates user in DB
      SEQUEL_DB[:users].insert({
        first_name: params[:first_name],
        last_name: params[:last_name],
        email: params[:email],
        password: Digest::MD5.hexdigest(params[:password]),
        born_on: params[:born_on]
      })

      # Sends mail after user creation using a resque worker (jobs/mailer.rb)
      # This needs to be running: bundle exec rake resque:work QUEUE=mailing
      Resque.enqueue(Mailer, params[:email], 'New account', 'Your account has been successfully created')

      {
        data: "User created successfully" # resposne
      }
    end

    # PUT method to update current user, authentication needed
    # 1. Use "login" to get the token
    # 2. Use this token in the Authorization key in header
    desc "Update User", {
      failure: [{ code: 401, message: 'Unauthorized' }], 
      headers: {
        "Authorization" => {
          description: "Validates your identity - Use JWT. Example: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9",
          required: true
        },
      }
    }    
    params do  
      optional :first_name, type: String, desc: 'First Name'
      optional :last_name, type: String, desc: 'Last Name'
      optional :email, type: String, desc: 'Email'
      optional :born_on, type: Date, desc: 'Date of birth'
    end  
    put '/:id' do  
      to_be_edited = Api::Models::User[id: params[:id]]     # user to be edited
      if current_user.can?(:edit, to_be_edited)  # does logged user have permission to edit this user?
        user = {}
        user[:first_name] = params[:first_name] unless params[:first_name].blank? 
        user[:last_name] = params[:last_name] unless params[:last_name].blank? 
        user[:email] = params[:email] unless params[:email].blank? 
        user[:born_on] = params[:born_on] unless params[:born_on].blank? 

        # updates user in DB
        if SEQUEL_DB[:users].where(id: params[:id]).update(user) > 0
          {
            data: "User updated successfully" # response
          }
        end
      else
        error!('Unauthorized', 401) # Users don't match or logged user has no permissions
      end
    end  

    # PATCH method to change password, authentication needed:
    # 1. Use "login" to get the token
    # 2. Use this token in the Authorization key in header
    desc "Change Password", {
      failure: [{ code: 401, message: 'Unauthorized' }], 
      headers: {
        "Authorization" => {
          description: "Validates your identity - Use JWT. Example: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9",
          required: true
        },
      }
    }    
    params do  
      requires :new_password, type: String, desc: 'New Password'
      requires :confirm_password, type: String, desc: 'Confirm Password'
      requires :new_password, validates_confirmation: :confirm_password
    end  
    patch '/:id/reset_password' do  
      to_be_edited = Api::Models::User[id: params[:id]]      # change password to this user
      if current_user.can?(:edit, to_be_edited)              # does logged user have permission to change this user's password?
        # changes password in DB using Digest::MD5
        if SEQUEL_DB[:users].where(id: params[:id]).update(password: Digest::MD5.hexdigest(params[:new_password])) > 0
          # sends email to user notifying the password has changed using resque worker (jobs/mailer.rb)
          # This needs to be running: bundle exec rake resque:work QUEUE=mailing
          Resque.enqueue(Mailer, to_be_edited[:email], 'Password Changed', 'Your password has been successfully changed')
          {
            data: "Password updated successfully" # resposne
          }
        end
      else
        error!('Unauthorized', 401)  # Users don't match or logged user has no permissions
      end
    end  

    # POST method that returs a token to be used in other resquests
    desc "Login", {
      failure: [{ code: 401, message: 'Invalid credentials' }], 
    }  
    params do
      requires :email, type: String, desc: "email username"
      requires :password, type: String, desc: "Password"
    end
    post '/login' do
      user = SEQUEL_DB[:users][email: params[:email]]     # finds user by email
      if  user && user[:password] == Digest::MD5.hexdigest(params[:password])   # password is correct
        {
          data: generate_token(params[:email])    # generates token to be sent in headers in following requests (auth.rb)
        }
      else
        error!('Invalid credentials', 401)  # password is incorrect
      end

    end

  end
end
