class FavoriteMailer < ApplicationMailer
  default from: 'wikiiki.donoreply@gmail.com' # use a fake email here or DMARC security from email vendor will block you.
  def new_comment(user, post, comment)
    headers['Message-ID'] = "<comments/#{comment.id}@your-app-name.example>"
    headers['In-Reply-To'] = "<post/#{post.id}@your-app-name.example>"
    headers['References'] = "<post/#{post.id}@your-app-name.example>"

    @user = user
    @post = post
    @comment = comment

    mail(to: user.email, subject: "New comment on #{post.title}")
  end
end
