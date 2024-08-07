
  module default{
    #声明抽象基类
  abstract type Base{
    create_user: User{
      default := (select User filter (.id = global current_user_id));
    }
    create_time: datetime{
      default := datetime_of_statement()
    }
    modified_user: User{
      rewrite insert,update using(
        .modified_user??(select User filter (global current_user_id = .id))
      )
    }
    modified_time: datetime {
      rewrite insert,update using(
      datetime_current()
      )
    }
  }
  }