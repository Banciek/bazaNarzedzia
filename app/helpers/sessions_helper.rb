module SessionsHelper

	def log_in(user)
		session[:user_id] = user.id
		session[:companies_ids] = user.companies.pluck(:id) if !user.companies.blank?
	end

	def remember(user)
		user.remember
		cookies.permanent.signed[:user_id] = user.id
		cookies.permanent[:remember_token] = user.remember_token
	end

	def forget(user)
		user.forget
		cookies.delete(:user_id)
		cookies.delete(:remember_token)
	end

	def log_out
		forget(current_user)
		session.delete(:user_id)
		session.delete(:companies_id)
		session.delete(:companies_ids)
		@current_user = nil
	end

	def current_user
		if (user_id = session[:user_id])
			@current_user ||= User.find_by(id: user_id)
		elsif (user_id = cookies.signed[:user_id])
			user = User.find_by(id: user_id)
			if user && user.authenticated?(:remember, cookies[:remember_token])
				log_in user
				@current_user = user
			end
		end	
	end

	def current_user?(user)
		user == current_user
	end
	
    def logged_in_user
      unless logged_in?
        store_location
        flash[:warning] = "Zaloguj się"
        redirect_to login_url
      end
    end

	def current_user_companies
		@current_user_companies ||= @current_user.companies
	end

	def logged_in?
		!current_user.nil?
	end

	def redirect_back_or(default)
		redirect_to(session[:forwarding_url] || default)
		session.delete(:forwarding_url)
	end

	def store_location
		session[:forwarding_url] = request.url if request.get?
	end



	def stored_location
		session[:forwarding_url]
	end

	def nav_link(link_text, page)
  		class_name = current_page?(page) ? 'active' : ''

  		content_tag(:li, class: class_name) do
    	link_to link_text, page
  		end
	end

	def admin_only
      redirect_back_or(current_user) unless current_user.admin?
    end

    def working_pulpit
      session[:last_company] = request.url if request.get?
    end

    def stored_pulpit
    	session[:last_company]
    end

end
