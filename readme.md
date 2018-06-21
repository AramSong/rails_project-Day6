##  20180621_ Day 10

### 검색

- 무언가 사용자 혹은 개발자가 원하는 데이터를 찾고자 할때
- 검색방법
  - 일치
  - 포함
  - 범위
  - ...
- 우리가 그동안에 검색했던 방법은 **일치**. Table에 있는 id와 일치하는 것. 이 컬럼은 인덱싱이 되어 있기 때문에 검색속도가 매우 빠르고 항상 고유한 값을 가진다.
  - Table에 있는 id로 검색을 할 때엔 `Model.find(id)`를 사용한다.
- Table에 있는 id값으로 해결하지 못하는 경우?
  - 사용자가 입력했던 값으로 검색해야하는 경우(`user_name`)
  - 게시글을 검색하는데 작성자, 제목으로 검색할 경우
    - `find`는 id 값으로면 찾을 수 있지만 다른 경우엔 사용할 수 없다.
  - Table에 있는 다른 컬럼으로 검색할 경우 `Model.find_by_컬럼명(value)`,  `Model.find_by(컬러명: value)`
  - `find_by`의 특징은 1개만 검색 된다. 일치하는 값이 없는 경우 `nil`
    - 여러 값이 있더라도 제일 처음에 넣은 하나만 출력
    - Day 9에서도 사용 아마 user_Controller에서 인듯

```ruby
rails c
u = User.find_by_user_id("xzcv")
=> nil
u = User.find_by_user_id("hello")
=> hello의 값을 가진 객체가 나온다??
```

- 추가적인 겁색 방법 : `Model.where(컬럼명: 검색어값)`
  - `User.where(user_name: "Hello")`
  - `where`의 특징 : 검색결과가 여러개. 결과값이 배열형태. 일치하는 값이 없는 경우에도 **빈 배열**이 나온다. 결과값이 비어있는 경우에 `nil?`메소드의 결과값이 `false`로 나옴
    - 컬럼에 일치하는 값을 모두 찾아준다. 
    - 결과값이 비어있는 경우에 `nil?` 메소드의 결과값이 `false` 

```ruby
rail c
User.where(user_id: "xzcv")
=> #<ActiveRecord:: Relation []> ##내일 과제로 나갈 덕타이핑
User.where(user_id: "xzcv").nil?
=> flase
```

- 포함?
  - 텍스트가 특정 단어/문장을 포함하고 있는가?
  - `Model.where("컬럼명 LIKE?", "%#{value}%")`
  - `Model.where("컬럼명 LIKE? '%#{value}%'")`되기는 하지만 쓰면 안된다.
    - 사용하면 안되는 이유?
      - SQL Injection(해킹)  
- 텍스트 패킹?? 

```ruby
2.3.4 :006 > User.where("user_id LIKE ?", "%h%")
  User Load (0.4ms)  SELECT "users".* FROM "users" WHERE (user_id LIKE '%h%')
 => #<ActiveRecord::Relation [#<User id: 1, user_id: "hello", password: nil, ip_address: nil, created_at: "2018-06-21 01:19:46", updated_at: "2018-06-21 01:19:46">]> 
```

*** 범위는 나중에 하기로!!

* 세션 : 원하는 키를 넣고 계속 사용할 수 있는?? 현재접속한 유저에 대한 정보뿐만 아니라 넣고자 하는 모든 정보를 넣을 수 있다. Hash 형태로 들어가 있다. 

  * 검색방법으로는 `u.empty?` , `length== 0`  : 비어있는가? 
  * `u1.nil?` : 값 자체가 없을 경우 
  * ` present ` : 존재하는가??
  * 꺼내서 쓸 때
    * `User.find(session[:current_user])` 형식으로!!

  ```ruby
  ----- BoardController
  def show
      #@post = Post.find(params[:id])
      set_post
      puts @post # @가 찍힌 변수??는 한 요청 안에서는 얼마든지 사용가능
    end
  
  def update
      # post = Post.find(params[:id])
      # post.title = params[:title]
      # post.contents = params[:contents]
      # post.save
      
      set_post
      @post.title = params[:title]
      @post.contents = params[:contents]
      @post.save
      redirect_to "/board/#{@post.id}"
    end
  
   def set_post
      @post = Post.find(params[:id])
    end
  ```

  * http://guides.rubyonrails.org/action_controller_overview.html     

    8 Filters

    ```ruby
    class ApplicationController < ActionController::Base
      before_action :set_post, only: [:show, :edit, :update, :destroy] # 괄호 안에 있는 뷰를 실행하기 전에 set_post가 미리 실행하기에 각각의 정의(?) 안에 set_post를 쓰지 않아도 된다.
      before_action :set_post, except: [:index, :create] # 위와 동일
        
      def show
        #set_post  
        #@post = Post.find(params[:id])
        puts @post # @가 찍힌 변수??는 한 요청 안에서는 얼마든지 사용가능
      end
        
    end
    ```

    ```ruby
    class ApplicationController < ActionController::Base
      protect_from_forgery with: :exception # csrf를 방지하는???
    end
    ```


### Method & Filter

* 액션에는 반복되는 코드들이 매우 많다. 이러한 반복되는 코드들을 하나의 메소드로 만들고 액션에서 메소드를 호출해서 사용할 수 있다.

*app/controllers/board_controller.rb*

```ruby
...
	def set_post
		@post = Post.find(params[:id])
	end
...
```



* 메소드에서 저장한 인스턴스 변수는 액션에서도 활용할 수 있다. Request Cycle이 동작하는 동안 계속 유효하다.
  * 하지만 단순히 메소드로 만들었다고 해서 메소드 호출까지 처리되는 것은 아니다. 액션이 실행되기 전에 반복되는 코드들을 미리 실행하는 filter를 활용하여 액션 실행을 처리할 수 있다.

*app/controller/board_controller.rb*

```ruby
class BoardController < ApplicationController
    before_action :set_post, only: [:show, :edit, :update, :destroy]
...        
```

* 옵션으로 `only`와 `except`를 줄 수 있는데 `only`옵션은 나열한 액션이 실행될 때만 필터가 동작하고, `except`옵션은 나열한 액션을 제외한 액션이 실행될 때 필터가 동작한다.
* filter 문서를 보다보면 `ApplicationController`를 상속받고 있으며, `ApplicationController`에서 선언한 메소드는 모든 컨트롤러에서 메소드로 쓸 수 있다고 적혀있다.
* 이를 활용하여 로그인과 관련된 일부 메소드를 구현해보자.

> 이는 Devise 잼을 활용할 때 낯설지 않게 하기 위해서, 그리고 그 코드가 어떻게 동작하는 지 알기 위해서 진행.

*app/controllers/application_controller.rb*

```ruby
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :user_signed_in?
  
  # 현재 로그인 된 상태니?
  
  def user_signed_in?
       #!session[:current_user].nil?#비어있으면 로그인된 상태가 아님  
      if session[:current_user].present?
      else
          redirect_to '/sign_in'
      end  
      session[:current_user].present?
  end
  # 로그인 되어있지 않으면 로그인하는 페이지로 이동시켜줘
  # 원형을 변경시킬 수 있는 메소드들은 !
  def authenticate_user!
    unless user_signed_in?
        redirect_to '/sign_in'
    end
  end
  # 현재 로그인 된 사람이 누구니?
  def current_user
      # 현재 로그인 됐니?
      if user_signed_in?
          # 되었다면 로그인 한 사람은 누구??
          @current_user = User.find(session[:current_user])
      end
  end
end
```

  *원형을 변경시킬 수 있는 메소드들은 ` !`*

- `user_signed_in?` : 메소드에 `?`가 붙는다면 리턴값이 `true`/ `false`임을 의미한다. 조건문의 조건으로 사용할 수 있다. 로그인 된 유저가 있는지 확인하는 메소드이다.
- `authenticate_user!` : 메소드에 `!`이 붙어 있으면 사용자의 요청과 맞지 않는 결과를 얻을 수 얻을 수 있다는 것을 의미한다. 해당 메소드는 로그인되지 않은 유저가 특정 페이지에 접근을 시도할 경우 로그인 페이지로 강제로 이동시키는 역할을 한다.
- `current_user` : 리턴값이 `nil`이거나 현재 로그인한 유저의 정보를 담는다. 후에 파이프(`||=`)를 이용하여 메소드를 보강해 나간다.

- rails action cable
  - 실시간 반영을 하기 위해서
  - react vue angular
    - 프리티어에서 힘들다?



##### helper method

원래는 view에서 controller의 메소드를 사용할 수 없다. 하지만 helper method로 지정이되면 view파일에서도 메소드를 호출해서 사용할 수 있다.

*app/controllers/board_controller.rb*

```
...
    before_action :authenticate_user!, except: [:index, :show]
...
```

* 메소드를 작성하면 다른 컨트롤러에서도 사용할 수 있다. 특히 `authenticate_user!`메소드의 경우 인증받지 못한 유저가 접근할 경우 로그인 페이지로 리디렉션 시키는 역할을 하기 때문에 필터를 활용하면 좋다.
* 나머지 두개의 메소드는 view에서 로직을 처리할 때 많이 사용되는데 기본적으로 컨트롤럴에 있는 메소드는 view에서 호출할 수 없다. view에서 컨트롤러의 메소드를 활용하기 위해서 `helper method`를 지정한다.

###  Model : 릴레이션 설정

`user.rb`

```ruby
class User < ApplicationRecord
    has_many :posts			#user가 여러개의 post를 가지고 있다
end
```

`post.rb`

```ruby
#user에 종속이 된다.class Post < ApplicationRecord
    belongs_to :user
end
```



## Association/Relation

- 레일즈를 사용하는 큰 이유중 하나는 ORM(Object Reloadtionship Mapper)을 매우 편하게 사용할 수 있다는 점이다. 기존의 다른 프레임워크(Spring 등)를 사용해본 사람이라면 더욱 쉽게 느낄 것이다.
- 한명의 유저는 여러개의 글을 작성할 수 있고, 하나의 글은 작성자 한명을 가질 수 있다. 이러한 관계를 **1:N**관계라 한다.
- 1:N 관계를 구현하기 위해서 먼저 N쪽이 되는 모델의 마이그레이션에 컬럼을 추가한다.

*db/migrate/create_posts.rb*

```
class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.string :title
      t.text   :contents
      t.integer :user_id
      t.timestamps
    end
  end
end
```

- 컬럼명은 `1이 되는 쪽의 모델명_id` 이다. `user`와 `post` 모델의 관계를 설정할 때 `post` 모델이 N쪽이 되기 때문에 `create_posts.rb`파일에 컬럼을 추가한다.

```
$ rake db:drop db:migrate
```

- 축약된 명령어로 drop과 migrate를 한번에 진행할 수 있다.

*app/models/user.rb*

```
...
    has_many :posts
...
```

*app/models/post.rb*

```
...
    belongs_to :user
...
```

- 각각의 모델에 코드를 한 줄씩 추가하면 두 모델 간의 **1:N** 관계가 완성된다.

```
> u = User.new
> u.user_name = "haha"
> u.password = "1234"
> u.save
> p = Post.new
> p.title = "Test Title"
> p.contents = "Test Contents"
> p.user_id = u.id
> p.save
> p.user
> u.posts
```

- 위와같은 방식으로 사용할 수 있다. 유저 쪽에서는 해당 유저가 작성한 모든 글을 출력할 수 있다.

*app/controllers/board_controller.rb*

```
...
  def create
    post = Post.new
    post.title = params[:title]
    post.contents = params[:contents]
    post.user_id = current_user.id
    post.save
    # post를 등록할 때 이 글을 작성한 사람은
    # 현재 로그인 되어 있는 유저이다.
    flash[:success] = "새 글이 등록되었습니다."
    redirect_to "/board/#{post.id}"
  end
...
```

- 글을 등록할 때 `user_id` 컬럼에 현재 로그인 된 유저의 id를 넣어주면 위 irb에서 진행했던 내용과 동일하게 관계를 설정할 수 있다.

*app/views/user/show.html.erb*

```
<p>이 유저가 작성한 글</p>
<% @user.posts.each do |post| %>
    <%= link_to post.title, "/board/#{post.id}" %><br>
<% end %>
```

- 유저가 작성한 글을 위와같이 확인할 수 있다.

*app/views/board/show.html.erb*

```
<p>작성자: <%= @post.user.user_name %></p>
```

- 글을 작성한 유저를 확인할 수 있다.