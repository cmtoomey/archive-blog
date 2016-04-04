require 'date'

POSTS_DIR = '_posts/'.freeze

post = ARGV[0]

File.open(POSTS_DIR + Date.today.strftime('%Y-%m-%d-') + 'newpost' + '.md', 'w') do |f|
    f.write(
        "---\nlayout: post\nsection-type: post\ntitle: Title\ncategory: Category\ntags: [ 'tag1', 'tag2' ]\n---")
end

puts('[+] Created ' + post + ' post')
