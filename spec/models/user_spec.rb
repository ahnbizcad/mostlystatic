require 'spec_helper'

describe "USERS -" do

	describe "TABLE subject user -" do
		#before { user = User.new(name: "Example User", 
		#													email: "user@example.com",
		#													password: "foobar",
		#													password_confirmation: "foobar") }
		let(:user) { FactoryGirl.create(:user) }		
	  subject { user }

		describe "attributes should respond and be valid" do			
			#attributes
			it { should respond_to(:name) }
		  it { should respond_to(:email) }
		  it { should respond_to(:password_digest) }
		  it { should respond_to(:password) }
		  it { should respond_to(:password_confirmation) }

		  #methods
		  it { should response_to(:authenticate) }

		  it { should be_valid }

	  end
	  describe "Name" do

	  	describe "that's blank should" do
		  	before { user.name = " " }
		  	describe "should be invalid" do
	    		it { should_not be_valid }
	    	end
	  	end
	  	describe "with more than 25 characters" do
		    before { user.name = "a" * (25+1) }
		    describe "should be invalid" do
	    		it { should_not be_valid }
	    	end
	  	end
	  	describe "that's already taken, case insensitive" do
	    	before { user_with_same_name = user.dup
    	  				 user_with_same_name.save }
    	  describe "should be invalid" do
	  			it { should_not be_valid }
	  		end
			end  	

		end		
		describe "Email" do
	  	#VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
			describe "that's blank should be invalid" do
		    before { user.email = " " }
	   	  it { should_not be_valid }
	  	end
	  	describe "in a valid format should be valid" do
		  	addresses = %w[user@foo.COM.
	  	 								A_US-ER@f.b.org.
	  	  							frst.lst@foo.jp.
	  	  			 				a+b@baz.cn]
	  		addresses.each do |valid_address|
		  		before { user.email = valid_address }
	  			it { should be_valid }
	  		end
	  	end
	  	describe "in invalid format should be invalid" do
		  	addresses = %w[user@foo,com.
	  									user_at_foo.org.
	  	 								example.user@foo.
	  	  							foo@bar_baz.com.
	  	   							foo@bar+baz.com]
	  		addresses.each do |invalid_address|
		  		before { user.email = invalid_address }
	  			it { should_not be_valid }
	  		end
	  	end
	  	#! syntax problem here
	  	describe "email address with mixed case" do
   			let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

   			it "should be saved as all lower-case" do
    			user.email = mixed_case_email
     			user.save
     			expect(user.reload.email).to eq mixed_case_email.downcase
   		  end
  		end
			describe "that's already taken" do
				before { user_with_same_email = user.dup 
								 user_with_same_email.email = user.email.upcase
	  						 user_with_same_email.save }
				describe "should be invalid" do	 					
					it { should_not be_valid }
				end		
			end

		end		
		describe "Password" do 

			describe "that's blank should be invalid" do
				before { user.password = " "
							 	user.password_confirmation = " " }
				describe "should be invalid" do
					it { should_not be_valid }
				end
			end
			describe "that's shorter than 6 characters" do
				before { user.password = "12345"
								 user.password_confirmation = "12345" }
				describe "should be invalid" do
					it { should_not be_valid }
				end
			end
			describe "that doesn't match the password_confirmation" do
				before { user.password = "mismatch" }
				describe "should be invalid" do
					it { should_not be_valid }
				end
			end

		end
		describe "Authenticate method return Value" do

 			before { user.save }
	 		let(:found_user) { User.find_by(email: user.email) }
 			
 			describe "with valid password" do
   			it { should eq found_user.authenticate(user.password) }
			end
 			describe "with invalid password" do
   			let(:user_for_invalid_password) { found_user.authenticate("invalid") }   			
    		it { should_not eq user_for_invalid_password }
    		specify { expect(user_for_invalid_password).to be_false }
  		end

		end

	end


  describe "PAGES subject page -" do
  	let(:base_title) { "Ruby on Rails Tutorial Sample App" }
  	subject { page }
	  
	  describe "users index page" do
	  	before { visit users_path }
	    it { should have_selector('h1', text: 'Users') }
	    it { should have_title(full_title('Users')) }
	  end
	  describe "user show page" do
	  	before { visit user_path(user) }
	    it { should have_selector('h1', text: 'Profile') }
	    it { should have_title(full_title('Profile')) }
	  end
	  describe "user new page" do
  		before { visit new_user_path }
	    it { should have_selector('h1', text: 'Sign Up') }
	    it { should have_title(full_title('Sign Up')) }
	  end
	  describe "user edit page" do
	  	before { visit edit_user_path }
	    it { should have_selector('h1', text: 'Edit Profile') }
	    it { should have_title(full_title('Edit Profile')) }
	  end	  
	end
	
end
