module ApplicationHelper
  def default_meta_tags
    {
      site: 'はやまっぷ',
      title: 'はやまっぷ',
      reverse: true,
      separator: '|',
      description: '思ったよりも間やめに到着する　ルート&乗り換え案内サービス',
      keywords: 'ルート案内',
      canonical: request.original_url,
      noindex: ! Rails.env.production?,
      icon: [
        { href: image_url('favicon.ico') },
      ],
      og: {
        site_name: 'はやまっぷ',
        title: 'はやまっぷ',
        description: '思ったよりも間やめに到着する　ルート&乗り換え案内サービス', 
        type: 'website',
        url: request.original_url,
        image: image_url('hayaogp.png'),
        locale: 'ja_JP',
      },

    }
  end
end
