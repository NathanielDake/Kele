require "httparty"

class Kele
  include HTTParty

  def initialize(email, password)
    response = self.class.post(base_api_endpoint("sessions"), body: { "email": email, "password": password })
    puts response.code
    raise "Invalid email or password" if response.code == 404
    @auth_token = response["auth_token"]
  end

  private

  def base_api_endpoint(end_point)
    "https://www.bloc.io/api/v1/#{end_point}"
  end
end

#code run in console >> Kele.new("email", "password")
#`initialize` is an instance method that is passed the parameters from
#the class method `new`. This happens when Ruby creates a new object,
#ex. `Student.new`, it looks for the initialize method in the `Student`
#class in order to set intial values. Class methods would have `self`
#as a prefix, i.e. `self.new`. Once the email and password are passed
#to initialize self.class.post takes several arguments to generate a
#response. Note, self.class in this case is equivalent to `HTTParty`,
#and `post` is one of its class methods. It takes the uri, followed
#by the options specified by bloc (body hash). Once sent to bloc, a
#response is generated (200 is success), which includes an authorization
#token. reference to blocs doc on API:
#http://docs.blocapi.apiary.io/#reference/0/sessions/retreive-auth-token