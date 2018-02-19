class HomeController < ApplicationController

  def index
    # cms data
    @page_part_1 = Cms::PagePart.where(id: 1)

    @search = Search.new

    # TODO: dynami
    @cities = [
      'Paris', 'Lyon', 'Marseille', 'Toulouse', 'Nice', 'Nantes', 'Strasbourg',
      'Montpellier', 'Bordeaux', 'Lille', 'Rennes', 'Reims', 'Le Have',
      'Saint-Étienne', 'Toulon', 'Grenoble', 'Dijon', 'Angers', 'Nîmes',
      'Villeurbanne', 'Le Mans', 'Clermond-Ferrand', 'Aix-en-Provence',
      'Brest', 'Limoges', 'Tours', 'Amiens', 'Perpignan', 'Metz',
      'Boulogne-Billancourt'
    ]

    @testimonials = [
      {
        author: {
          name: 'Kévin HEYDENS',
          avatar_url: 'default-avatar.png'
        },
        published_at: '23/08/2016',
        body: 'Bravo pour votre association, vive la solidarité et la communauté libre !'
      },
      {
        author: {
          name: 'Michel VIN',
          avatar_url: 'default-avatar.png'
        },
        published_at: '13/08/2016',
        body: 'Bravo pour cette initiative qui va me permettre de proposer des trajets à frais partagés en covoiturage avec mon véhicule de collection (Ford T) et en particulier des tours sur le remblai de La Baule'
      },
      {
        author: {
          name: 'Émilie HILLEREAU',
          avatar_url: 'default-avatar.png'
        },
        published_at: '08/08/2016',
        body: 'Ravie de participer au développement du VRAI covoiturage qui me manque tant… Vive le covoiturage LIBRE !'
      }
    ]
  end

end
