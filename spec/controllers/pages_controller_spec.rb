require 'spec_helper'

describe PagesController do

  describe "GET 'home'" do
    it "should be successful" do
      get 'home'
      response.should be_success
    end
  end

  describe "GET 'activities'" do
    it "should be successful" do
      get 'activities'
      response.should be_success
    end
  end

  describe "GET 'myteam'" do
    it "should be successful" do
      get 'myteam'
      response.should be_success
    end
  end

  describe "GET 'signout'" do
    it "should be successful" do
      get 'signout'
      response.should be_success
    end
  end

  describe "GET 'myaccount'" do
    it "should be successful" do
      get 'myaccount'
      response.should be_success
    end
  end

end
