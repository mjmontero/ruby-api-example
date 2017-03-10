class ValidatesConfirmation  < Grape::Validations::Base
  def validate_param!(attr_name, params)        
    if params[attr_name] != params[@option]
      fail Grape::Exceptions::Validation, params: [@scope.full_name(attr_name)], message: 'must match password_confirmation'
    end        
  end
end
