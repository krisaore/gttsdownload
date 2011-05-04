GoogleTTStoMp3::Application.routes.draw do
  root :to => "translate#index"

  get "translate/index"

  match 'translate' => 'translate#translate', :as => :translate # this will give the ability to use <%= link_to "Translate", translate_path %>
  match 'batch_translate' => 'translate#batch_translate', :as => :batch_translate

end

