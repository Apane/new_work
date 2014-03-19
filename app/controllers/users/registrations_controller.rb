class Users::RegistrationsController < Devise::RegistrationsController
  before_filter :load_zip_codes, only: [:create]

  # GET /resource/edit
  def edit
    render :edit
  end

  # POST /resource
  def create
    build_resource(sign_up_params)
    unless @zip_codes.include?(resource.zip)
     if resource.save
        if resource.active_for_authentication?
          set_flash_message :notice, :signed_up if is_navigational_format?
          sign_up(resource_name, resource)
          respond_with resource, :location => after_sign_up_path_for(resource)
        else
          set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
          expire_session_data_after_sign_in!
          respond_with resource, :location => after_inactive_sign_up_path_for(resource)
        end
      else
        clean_up_passwords resource
        respond_with resource
      end
    else
      redirect_to home_path, error: 'You are not allowed to sign up from this address.'
    end
  end

  def update
    if params[resource_name][:password].blank?
      params[resource_name].delete(:password)
      params[resource_name].delete(:password_confirmation) if params[resource_name][:password_confirmation].blank?
    end
    # Override Devise to use update_attributes instead of update_with_password.
    # This is the only change we make.
    if resource.update_attributes(params[resource_name])
      set_flash_message :notice, :updated
      # Line below required if using Devise >= 1.2.0
      sign_in resource_name, resource, :bypass => true
      redirect_to after_update_path_for(resource)
    else
      clean_up_passwords(resource)
      render_with_scope :edit
    end
  end

  def account_registration
     @user = User.find(current_user.id)
  end

  def load_zip_codes
    @zip_codes = ['10453', '10457', '10460', '10458', '10467', '10468', '10451', '10452', '10456', '10454', '10455', '10459',
      '10474', '10463', '10471', '10466', '10469', '10470', '10475', '10461', '10462', '10464', '10465', '10472', '10473', '11212',
      '11213', '11216', '11233', '11238', '11209', '11214', '11228', '11204', '11218', '11219', '11230', '11234', '11236', '11239',
      '11223', '11224', '11229', '11235', '11201', '11205', '11215', '11217', '11231', '11203', '11210', '11225', '11226', '11207',
      '11208', '11211', '11222', '11220', '11232', '11206', '11221', '11237', '10026', '10027', '10030', '10037', '10039', '10001',
      '10011', '10018', '10019', '10020', '10036', '10029', '10035', '10010', '10016', '10017', '10022', '10012', '10013', '10014',
      '10004', '10005', '10006', '10007', '10038', '10280', '10002', '10003', '10009', '10021', '10028', '10044', '10128', '10023',
      '10024', '10025', '10031', '10032', '10033', '10034', '10040', '11361', '11362', '11363', '11364', '11354', '11355', '11356',
      '11357', '11358', '11359', '11360', '11365', '11366', '11367', '11412', '11423', '11432', '11433', '11434', '11435', '11436',
      '11101', '11102', '11103', '11104', '11105', '11106', '11374', '11375', '11379', '11385', '11691', '11692', '11693', '11694',
      '11695', '11697', '11004', '11005', '11411', '11413', '11422', '11426', '11427', '11428', '11429', '11414', '11415', '11416',
      '11417', '11418', '11419', '11420', '11421', '11368', '11369', '11370', '11372', '11373', '11377', '11378', '10302', '10303',
      '10310', '10306', '10307', '10308', '10309', '10312', '10301', '10304', '10305', '10314']
  end

private

  def after_sign_up_path_for(resource)
    welcome_path
  end

  def after_update_path_for(resource)
    welcome_path
  end


end
