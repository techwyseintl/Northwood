class AddCareerReports < ActiveRecord::Migration
  def self.up
  	CareerReport.create(:report_url => 'http://', :report_name => 'A Career as a Mortgage Consultant- Do you have what it takes?')
  	CareerReport.create(:report_url => 'http://', :report_name => 'An Overview of the Mortgage Industry')
  	CareerReport.create(:report_url => 'http://', :report_name => 'Comparing Rent to a Mortgage Payment')
  	CareerReport.create(:report_url => 'http://', :report_name => 'Do You Have What It Takes?')
  	CareerReport.create(:report_url => 'http://', :report_name => 'First Time Buyer Information')
  	CareerReport.create(:report_url => 'http://', :report_name => 'Why Use a Mortgage Broker?')
  	CareerReport.create(:report_url => 'http://', :report_name => 'Why You Belong at Northwood!')
  end

  def self.down
  end
end
