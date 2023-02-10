# frozen_string_literal: true

# This is an abstract class that provides a clean architecture using dry-monads
# for the execution of business operations. dry-monads provides a set of monads
# that can be used to control data flow and errors in an efficient and reliable
# manner.
# This class is responsible for creating an execution framework for operations,
# allowing for the execution of individual operations, grouping them into more
# complex operations and reusing code between operations. This class also offers
# flexibility by allowing for new operations to be added to the existing execution
# schema and by allowing for the extension of existing operations. Additionally,
# this class provides a low-level abstraction of the execution flow, allowing
# developers to focus on the specific business code.
class OperationBase
  include Dry::Monads[:do, :maybe, :result, :try]

  def find_user(id)
    user = User.find_by(id: id)

    return Failure(base: I18n.t('operations.base.profile_not_found')) if user.blank?

    Success(user)
  end

  def find_and_validate_user_profile(id)
    user = User.find_by(id: id)

    return Failure(base: I18n.t('operations.base.profile_not_found')) if user.blank?
    return Failure(base: I18n.t('operations.base.invalid_user')) unless user.profile?

    Success(user)
  end

  def find_and_validate_user_admin(id)
    user = User.find_by(id: id)

    return Failure(base: I18n.t('operations.base.admin_not_found')) if user.blank?
    return Failure(base: I18n.t('operations.base.user_is_not_admin')) unless user.admin?

    Success(user)
  end

  # :reek:FeatureEnvy
  def validate_contract(contract_klass, attributes)
    contract = contract_klass.new.call(attributes)

    return Success(contract.to_h) if contract.success?

    Failure(contract.errors)
  end

  def create_user_on_database(attributes)
    user = User.new(attributes)

    return Success(user) if user.save

    Failure(user.errors)
  end

  def delete_user_on_database(user_id)
    user = User.find_by(id: user_id)

    return Failure(base: I18n.t('operations.base.profile_not_found')) if user.blank?
    return Failure(user.errors) unless user.destroy

    Success(nil)
  end

  def update_user_password(user, password)
    return Success(user) if user.update(password: password)

    Failure(user.errors.to_hash)
  end

  def myself?(admin_id, user_id)
    return Success() unless admin_id == user_id

    Failure(base: I18n.t('operations.base.myself'))
  end

  def generate_random_password
    SecureRandom.hex(20)
  end

  def add_random_password_to_attributes(attributes)
    Success(
      attributes.merge(password: generate_random_password)
    )
  end

  def send_welcome_email_to_user(user)
    Success(AdminContext::UserMailer.welcome(user).deliver_later)
  end
end
