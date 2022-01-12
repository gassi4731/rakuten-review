require 'bundler/setup'
Bundler.require
require 'open-uri'
require 'net/http'
require "json"
require 'uri'
require 'csv'
require './rakutenReview.rb'

# サンプルURL: https://review.rakuten.co.jp/item/1/355731_10000131
print 'レビューのURLを入力してください: '
input_url = gets.chomp

reviewManager = RakutenReviewManager.new(input_url)

reviews = reviewManager.getAllReviews

CSV.open('Review.csv','w') do |csv|
  csv << ['Star', 'Comment']
  reviews.each do |bo|
      csv << bo
  end
end

reviewManager.quit()
