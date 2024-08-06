module default{
     #声明用户名，密码等自定义约束属性
  abstract constraint max_length(length: int64){
    errmessage := "长度必须少于{length}字符";
    using(len(__subject__) <= length);
  }
    # 创作者
  type Author extending User{
    multi follow := .<fun[is Author];
    multi fun:Author{
      constraint exclusive on ((@source,@target)){
        errmessage := "你已经关注过该博主了"
      }
    };
    multi posts: Post{
      on target delete allow;
    }
    multi comments: Comment;
  }
  # 用户基类
  type User extending Base{
    required username: str{
      constraint max_length(20);
    }
    required password: str{
      constraint max_length(20);
    }
    required email: str{
      constraint exclusive
    };
    avatar:str{
      annotation title := "头像"
    };
    ip:str{
      annotation description := "用户当前IP信息"
    }
  }
    #触发器；
    # trigger add_follow after insert for .follow do (
    #   (select __new__ except __old__ limit 1).fans += __subject__;
    # )
  type Admin extending User{
    required enable: bool; 
  }
}