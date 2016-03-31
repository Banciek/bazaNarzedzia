class Company < ActiveRecord::Base
	has_many :manages, dependent: :destroy
	has_many :users, through: :manages


	validates :name, presence: true, uniqueness: true, length: {maximum: 255}
	validates :full_name, length: {maximum: 255}
	VALID_ZIP_CODE_REGEX = /\A\d{2}[-]\d{3}\z/i
	validates :city, length: {maximum: 255}
	validates :street, length: {maximum: 255}
	validates :street_address, length: {maximum: 10}
	validates :zip_code, length: {is: 6}, format: {with: VALID_ZIP_CODE_REGEX}, allow_blank: true
	validates :nip, uniqueness: {case_sensitive: false}, length: {in: 10..13}, allow_blank: true
	validates :regon, uniqueness: {case_sensitive: false}, length: {is: 9}, allow_blank: true


end