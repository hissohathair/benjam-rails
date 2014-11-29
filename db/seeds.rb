# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).


# Top level items: ID, name, position
#
item_list = [
  [ 1, "Food", 2, "c_food.jpg", "c_food.wav" ],
  [ 2, "TV", 3, "c_tv.jpg", "c_tv.wav" ],
  [ 3, "pool", 4, "c_swim.jpg", "c_swim.wav"],
  [ 4, "Computer", 1, "c_computer.jpg", "c_computer.wav" ]
]

item_list.each do |id, name, position, image_path, audio_path|
  image = File.read("app/assets/images/#{image_path}")
  audio = File.read("app/assets/audio/#{audio_path}")
  Item.create( id: id, name: name, position: position, image: image, audio: audio)
end


# Second level items: ID, name, parent, position
#
children_item_list = [
  [ 5, "biscuit", 1, 1, "biscuit.jpg", "biscuit.wav" ],
  [ 6, "bread", 1, 2, "bread.jpg", "bread.wav" ],
  [ 7, "breadsticks", 1, 3, "breadsticks.jpg", "breadsticks.wav" ],
  [ 8, "dinner", 1, 4 , "dinner.jpg", "dinner.wav"],
  [ 9, "lollies", 1, 5, "lollies.jpg", "lollies.wav" ],
  [ 10, "pink biscuit", 1, 6, "pinkbiscuit.jpg", "pinkbiscuit.wav" ],
  [ 11, "rice cakes", 1, 7, "ricecrackers.jpg", "ricecrackers.wav" ],
  [ 12, "nutella toast", 1, 8, "toast.jpg", "toast.wav" ],


  [ 13, "Barney", 2, 1, "i_admin.png", "c_tv.wav" ],
  [ 14, "Brainy Baby", 2, 2, "i_admin.png", "c_tv.wav"  ],
  [ 15, "Elmo", 2, 3, "i_admin.png", "c_tv.wav"  ],
  [ 16, "Giggle Bellies", 2, 4, "i_admin.png", "c_tv.wav"  ],
  [ 17, "Hi-5", 2, 5, "i_admin.png", "c_tv.wav"  ],
  [ 18, "music", 2, 6, "i_admin.png", "c_tv.wav"  ],
  [ 19, "Wiggles", 2, 7, "i_admin.png", "c_tv.wav"  ],

  [ 20, "Elmo and I know it", 4, 1,"i_admin.png", "c_tv.wav"  ],
  [ 21, "Gangnam Style", 4, 2, "i_admin.png", "c_tv.wav"  ],
  [ 22, "Giggle Bellies", 4, 3, "i_admin.png", "c_tv.wav"  ],
  [ 23, "Hi-5", 4, 4, "i_admin.png", "c_tv.wav"  ],
  [ 24, "One Direction", 4, 5, "i_admin.png", "c_tv.wav"  ]
]

children_item_list.each do |id, name, parent, position, image_path, audio_path|
  image = File.read("app/assets/images/#{image_path}")
  audio = File.read("app/assets/audio/#{audio_path}")
  Item.create( id: id, name: name, parent_id: parent, position: position, image: image, audio: audio )
end

ActiveRecord::Base.connection.reset_pk_sequence!('items')