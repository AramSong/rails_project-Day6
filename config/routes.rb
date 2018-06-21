Rails.application.routes.draw do
  root 'board#index'
  
  #User
  
  #전체목록
  get '/users' => 'user#index'
  
  #회원가입
  get 'user/sign_up' => 'user#sign_up'
  get '/sign_in'  =>'user#sign_in'
  post '/sign_in' =>'user#login'
  post '/users' => 'user#create'
  
  #로그아웃
  get '/logout' =>'user#logout'
  
  #해당 회원 정보 보여주기
  get 'user/:id'  => 'user#show'
  
  #정보수정
  get 'user/:id/edit' => 'user#edit'
  put 'user/:id'  =>'user#update'
  patch 'user/:id' =>'user#update'
  


  #Board
  
  #전체목록
  get '/boards' => 'board#index'
   #새 글 쓰기
  get '/board/new' => 'board#new'
  #글 하나 불러오기
  get '/board/:id' => 'board#show'
  post '/boards' => 'board#create'
  #수정하기
  get '/board/:id/edit' =>'board#edit'
  #몇 번째 글인지 알면 해당 id로 요청 방식만다름.
  patch '/board/:id'  =>'board#update'
  #삭제
  delete '/board/:id' => 'board#destroy'
  
  #Cafe
  
  #전체목록
  get '/caves' => 'cafe#index'
  #새 글 쓰기
  get '/cafe/new' => 'cafe#new'
  #글 하나 불러오기
  get '/cafe/:id' => 'cafe#show'
  post '/caves' => 'cafe#create'
  #수정하기
  get '/cafe/:id/edit'=>'cafe#edit'
  patch '/cafe/:id' =>'cafe#update'
  #삭제
  delete '/cafe/:id' => 'cafe#destroy'
    
end
