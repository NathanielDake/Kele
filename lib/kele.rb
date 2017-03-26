require "httparty"
require './lib/roadmap.rb'


class Kele
  include HTTParty
  include Roadmap

  def initialize(email, password)
    response = self.class.post(base_api_endpoint("sessions"), body: { "email": email, "password": password })
    raise "Invalid email or password" if response.code == 404
    @auth_token = response["auth_token"]
  end

  #retrieve myself as a bloc user in the form of a JSON blob
  def get_me
    response = self.class.get(base_api_endpoint("users/me"), headers: { "authorization" => @auth_token })
    @user_data = JSON.parse(response.body)
  end

  def get_mentor_id
    get_me["current_enrollment"]["mentor_id"]
  end

  #retrieve my mentors availability
  def get_mentor_availability(mentor_id)
    response = self.class.get(base_api_endpoint("mentors/#{mentor_id}/student_availability"), headers: { "authorization" => @auth_token })
    @mentor_availability = JSON.parse(response.body)
  end

  def get_message(page_number = nil)
    if page_number.nil?
      response = self.class.get(base_api_endpoint("message_threads"), headers: { "authorization" => @auth_token })
    else
      response = self.class.get(base_api_endpoint("message_threads?page=#{page_number}"), headers: { "authorization" => @auth_token })
    end
    @messages = JSON.parse(response.body)
  end

  def create_message(user_id, recipient_id, subject, message, token = nil)
    response = self.class.post(base_api_endpoint("messages"),
      body: {
          "user_id": user_id,
          "recipient_id": recipient_id,
          "token": token,
          "subject": subject,
          "stripped-text": message
      },
      headers: {"authorization" => @auth_token})
    puts response
  end

  def create_submission(checkpoint_id, assignment_branch, assignment_commit_link, comment, enrollment_id)
    response = self.class.post(base_api_endpoint("checkpoint_submissions"),
      body: {
          "checkpoint_id": checkpoint_id,
          "assignment_branch": assignment_branch,
          "assignment_commit_link": assignment_commit_link,
          "comment": comment,
          "enrollment_id": enrollment_id
      },
      headers: {
          "authorization" => @auth_token
      })
    puts response
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

#get_me uses the HTTParty's (self.class) get method, which takes a url, and
# a set of options, in this case header containing an authorization
#and returns a response object, set equal to response. This response
#has a body property which is parsed by the JSON parse method. and set to
#be the @user_data