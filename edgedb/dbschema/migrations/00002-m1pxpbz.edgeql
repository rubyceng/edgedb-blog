CREATE MIGRATION m1pxpbzse4urkmcsauiyd25ikhnumz6uouo4kkiy3wifgbgirozj6a
    ONTO m14ugst4cnd4w3qn7nx7vdjzrglg4v73guot63x2vnbessqjx4r46q
{
  ALTER TYPE default::User {
      CREATE PROPERTY avatar: std::str {
          CREATE ANNOTATION std::title := '头像';
      };
      CREATE PROPERTY ip: std::str {
          CREATE ANNOTATION std::description := '用户当前IP信息';
      };
  };
  ALTER TYPE default::Author {
      CREATE MULTI LINK comments: default::Comment;
      ALTER LINK fun {
          CREATE CONSTRAINT std::exclusive ON ((@source, @target)) {
              SET errmessage := '你已经关注过该博主了';
          };
      };
  };
  ALTER TYPE default::Comment {
      DROP ACCESS POLICY has_delete;
  };
  ALTER TYPE default::Comment {
      DROP LINK author;
  };
  ALTER TYPE default::Comment {
      CREATE LINK author := (.<comments[IS default::Author]);
  };
  ALTER TYPE default::Comment {
      CREATE ACCESS POLICY has_delete
          ALLOW DELETE USING ((((GLOBAL default::current_user_id IN .author.id) ?? false) OR ((GLOBAL default::current_user_id IN (SELECT
              default::Admin.id
          )) ?? false))) {
              SET errmessage := '没有权限删除该评论';
          };
  };
  ALTER TYPE default::Post {
      CREATE MULTI LINK comment: default::Comment;
  };
  CREATE TYPE default::PostType EXTENDING default::Base {
      CREATE MULTI LINK posts: default::Post;
      CREATE LINK child_type: default::PostType;
      CREATE REQUIRED PROPERTY text: std::str {
          CREATE CONSTRAINT std::exclusive;
      };
  };
  ALTER TYPE default::Post {
      CREATE LINK post_type := (.<posts[IS default::PostType]);
  };
  ALTER TYPE default::Tag {
      DROP LINK paren_tag;
      DROP LINK child_tags;
  };
};
