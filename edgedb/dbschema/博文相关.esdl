module default{
     #声明抽象自定义链接
  # abstract link link_with_strength{
    
  # }

  #博文
  type Post extending Base{
    required title: str;
    required body: str;
    multi author: User;
    state: State{
      default := State.Complie
    };
    post_time:datetime{
      rewrite insert using(
        datetime_of_statement()
        if (__subject__.state ?= State.Full)
        else .post_time
      )
    }
    multi tags: Tag;
    multi comment: Comment;
    post_type := .<posts[is PostType];
    #策略；
    access policy has_hidden
    allow select
    using ( (.state ?= State.Full) or (global current_user_id in .author.id)??false);
    access policy has_update
    allow update
    using ( (global current_user_id in .author.id)??false);
    access policy has_insert
    allow insert
    using ( true);
    access policy has_delete
    allow delete
    using ( (global current_user_id in .author.id)??false or (global current_user_id in (select Admin.id))??false);
  }
  # 评论
  type Comment extending Base{
    author := .<comments[is Author];
    required text: str;
    recover: Comment;
    access policy has_delete
    allow delete
    using ( (global current_user_id in .author.id)??false or (global current_user_id in (select Admin.id))??false){
      errmessage:= "没有权限删除该评论"
    };
  }
  #标签 跟post同样是多对多
  type Tag extending Base{
    posts:= .<tags[is Post];
    required body: str;
  }
  type PostType extending Base{
    required text:str{
      constraint exclusive;
    };
    child_type: PostType;
    multi posts: Post;
  }
}