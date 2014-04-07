class AddPreferencesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :preferences, :text, default: "{\"books\":{\"book_n1\":\"\",\"book_n2\":\"\",\"book_n3\":\"\",\"book_n4\":\"\",\"book_n5\":\"\"},\"movies\":{\"movie_n1\":\"\",\"movie_n2\":\"\",\"movie_n3\":\"\",\"movie_n4\":\"\",\"movie_n5\":\"\"},\"blogs\":{\"blog_n1\":\"\",\"blog_n2\":\"\",\"blog_n3\":\"\",\"blog_n4\":\"\",\"blog_n5\":\"\"},\"websites\":{\"website_n1\":\"\",\"website_n2\":\"\",\"website_n3\":\"\",\"website_n4\":\"\",\"website_n5\":\"\"},\"people\":{\"person_n1\":\"\",\"person_n2\":\"\",\"person_n3\":\"\",\"person_n4\":\"\",\"person_n5\":\"\"},\"things\":{\"thing_n1\":\"\",\"thing_n2\":\"\",\"thing_n3\":\"\",\"thing_n4\":\"\",\"thing_n5\":\"\"},\"activities\":{\"activity_n1\":\"\",\"activity_n2\":\"\",\"activity_n3\":\"\",\"activity_n4\":\"\",\"activity_n5\":\"\"},\"values\":{\"value_n1\":\"\",\"value_n2\":\"\",\"value_n3\":\"\",\"value_n4\":\"\",\"value_n5\":\"\"},\"pets\":{\"pet_n1\":\"\",\"pet_n2\":\"\",\"pet_n3\":\"\",\"pet_n4\":\"\",\"pet_n5\":\"\"}}"
  end
end
