class ToDoAppController < ActionController::Base
  @@r = Rails.configuration.repository

  def es_save(item)
    @@r.save(item)
    @@r.client.indices.flush :index => :mynotesindex
  end

  def todo
    case session[:what_to_show]
      when 'show_completed'
        @allitems = @@r.search('done:true').to_a.map(&:to_hash)
      when 'show_active'
        @allitems = @@r.search('done:false').to_a.map(&:to_hash)
      else
        @allitems = @@r.search('*').to_a.map(&:to_hash)
    end
  end

  def withitem_do
    item = @@r.find(params[:id].to_i).to_hash
    item['done'] = !item['done']
    es_save(item)
    redirect_to '/todo'
  end

  def buttonsatbottom
    session['what_to_show'] = 'show_all'
    if params.has_key?('buttontoshowcompleted')
      session['what_to_show'] = 'show_completed'
    end
    if params.has_key?('buttontoshowactive')
      session['what_to_show'] = 'show_active'
    end
    redirect_to '/todo'
  end

  def showeditformfor
    @item = @@r.find(params[:id].to_i).to_hash
    render 'show_editform'
  end

  def savechangesfor
    new_desc = params[:newdescription]
    item = @@r.find(params[:id].to_i).to_hash
    item['description'] = new_desc
    es_save(item)
    redirect_to '/todo'
  end

  def doaddnewitem
    itemtoadd = params[:itemtoadd]
    new_id = SecureRandom.hex.gsub(/[a-c]/, '').to_i
    item = {id: new_id, done: false, description: itemtoadd}
    es_save(item)
    redirect_to '/todo'
  end
end

