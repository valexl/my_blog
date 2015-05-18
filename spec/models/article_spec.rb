require 'rails_helper'

RSpec.describe Article, type: :model do
  before(:each) do
    @article = FactoryGirl.build(:article)
  end

  describe "will successfully save if" do
    after(:each) do
      expect(@article.save!).to eq(true)
    end
    
    it 'build from FactoryGirl' do
    end
  end

  it 'create 2 ArticleContent' do
    expect{
      @article.save!
    }.to change(ArticleContent, :count).by(2)
  end

  describe 'has method' do
    it "count_comments" do
      @article.save!
      FactoryGirl.create(:comment, article: @article)
      expect(@article.count_comments).to eq(1)
    end
    
    it 'published? wiche return published status for given language' do
      @article.russian_content.published = false
      @article.english_content.published = false

      expect(@article.published?(:ru)).to eq(false)
      expect(@article.published?(:en)).to eq(false)
     
      @article.russian_content.published = true
      @article.english_content.published = true
      
      expect(@article.published?('en')).to eq(true)
      expect(@article.published?('ru')).to eq(true)
    end

    it 'toggle_published! change article as published for language to opposite of current' do
      @article.russian_content.published = false
      @article.english_content.published = true

      @article.toggle_published!(:ru)
      @article.toggle_published!('en')
      expect(@article.published?(:ru)).to eq(true)
      expect(@article.published?(:en)).to eq(false)
    end


    it 'set_published! mark article as published for language' do
      @article.russian_content.published = false
      @article.english_content.published = false

      @article.set_published!(:ru)
      @article.set_published!('en')
      expect(@article.published?(:ru)).to eq(true)
      expect(@article.published?(:en)).to eq(true)
    end

    it 'set_unpublished! mark article as unpublished for language' do
      @article.russian_content.published = true
      @article.english_content.published = true

      @article.set_unpublished!(:ru)
      @article.set_unpublished!('en')
      expect(@article.published?(:ru)).to eq(false)
      expect(@article.published?(:en)).to eq(false)
    end


    it 'title which returns title in given languages' do
      @article.russian_content.title = 'Заголовок'
      @article.english_content.title = 'Title'
      expect(@article.title(:ru)).to eq('Заголовок')
      expect(@article.title('ru')).to eq('Заголовок')
      expect(@article.title(:en)).to eq('Title')
      expect(@article.title('en')).to eq('Title')
    end

    it 'content which returns content in given languages' do
      @article.russian_content.content = 'Содержимое'
      @article.english_content.content = 'Content'
      expect(@article.content(:ru)).to eq('Содержимое')
      expect(@article.content('ru')).to eq('Содержимое')
      expect(@article.content(:en)).to eq('Content')
      expect(@article.content('en')).to eq('Content')
    end

    it 'fully_filled_ru? wich russian_content.return true only if has title russian_content.content and image_ru' do
       @article.russian_content.title  = nil
       @article.russian_content.content = nil
       @article.russian_content.image  = nil

       expect(@article.fully_filled_ru?).to eq(false)
       @article.russian_content.title  = 'Заголовок'
       expect(@article.fully_filled_ru?).to eq(false)
       @article.russian_content.content  = 'Описание'
       expect(@article.fully_filled_ru?).to eq(false)
       File.open("#{::Rails.root}/spec/files/img.jpeg") do |f|
          @article.russian_content.image  = f
        end
       expect(@article.russian_content.image.present?).to eq(true)
       expect(@article.fully_filled_ru?).to eq(true)
    end

    it 'fully_filled_en? wich return true only if has english_content.title english_content.content and english_content.image' do
       @article.english_content.title  = nil
       @article.english_content.content = nil
       @article.english_content.image  = nil

       expect(@article.fully_filled_en?).to eq(false)
       @article.english_content.title  = 'Заголовок'
       expect(@article.fully_filled_en?).to eq(false)
       @article.english_content.content  = 'Описание'
       expect(@article.fully_filled_en?).to eq(false)
       File.open("#{::Rails.root}/spec/files/img.jpeg") do |f|
          @article.english_content.image  = f
        end
       expect(@article.english_content.image.present?).to eq(true)
       expect(@article.fully_filled_en?).to eq(true)
    end

    it 'get_content wich return content for given lang' do
      expect(@article.get_content(:ru)).to eq(@article.russian_content)
      expect(@article.get_content(:en)).to eq(@article.english_content)
    end

    it 'russian_content wich build new article_content' do
      @article.article_contents.destroy_all
      expect(@article.russian_content.class).to eq(ArticleContent)
      expect(@article.russian_content.lang).to eq('ru')
    end

    it 'russian_content wich given exist article_content' do
      @article.article_contents.destroy_all
      @article.save!
      ru_article_content = FactoryGirl.create(:article_content, lang: :ru, article: @article)
      en_article_content = FactoryGirl.create(:article_content, lang: :en, article: @article)
      @article.reload
      expect(@article.article_contents.count).to eq(2)
      expect(@article.russian_content).to eq(ru_article_content)
    end

    it 'english_content wich build new article_content' do
      @article.article_contents.destroy_all
      expect(@article.english_content.class).to eq(ArticleContent)
      expect(@article.english_content.lang).to eq('en')
    end

    it 'russian_content wich given exist article_content' do
      @article.article_contents.destroy_all 
      @article.save!
      ru_article_content = FactoryGirl.create(:article_content, lang: :ru, article: @article)
      en_article_content = FactoryGirl.create(:article_content, lang: :en, article: @article)
      @article.reload
      expect(@article.article_contents.count).to eq(2)
      expect(@article.english_content).to eq(en_article_content)
    end

  end
end
