CREATE MIGRATION m14ugst4cnd4w3qn7nx7vdjzrglg4v73guot63x2vnbessqjx4r46q
    ONTO initial
{
  CREATE ABSTRACT CONSTRAINT default::max_length(length: std::int64) {
      SET errmessage := '长度必须少于{length}字符';
      USING ((std::len(__subject__) <= length));
  };
  CREATE GLOBAL default::current_user_id -> std::uuid;
  CREATE ABSTRACT TYPE default::Base {
      CREATE PROPERTY create_time: std::datetime {
          SET default := (std::datetime_of_statement());
      };
      CREATE PROPERTY modified_time: std::datetime {
          CREATE REWRITE
              INSERT 
              USING (std::datetime_current());
          CREATE REWRITE
              UPDATE 
              USING (std::datetime_current());
      };
  };
  CREATE TYPE default::User EXTENDING default::Base {
      CREATE REQUIRED PROPERTY password: std::str {
          CREATE CONSTRAINT default::max_length(20);
      };
      CREATE REQUIRED PROPERTY email: std::str {
          CREATE CONSTRAINT std::exclusive;
      };
      CREATE REQUIRED PROPERTY username: std::str {
          CREATE CONSTRAINT default::max_length(20);
      };
  };
  CREATE TYPE default::Admin EXTENDING default::User {
      CREATE REQUIRED PROPERTY enable: std::bool;
  };
  ALTER TYPE default::Base {
      CREATE LINK create_user: default::User {
          SET default := (SELECT
              default::User
          FILTER
              (.id = GLOBAL default::current_user_id)
          );
      };
      CREATE LINK modified_user: default::User {
          CREATE REWRITE
              INSERT 
              USING ((.modified_user ?? (SELECT
                  default::User
              FILTER
                  (GLOBAL default::current_user_id = .id)
              )));
          CREATE REWRITE
              UPDATE 
              USING ((.modified_user ?? (SELECT
                  default::User
              FILTER
                  (GLOBAL default::current_user_id = .id)
              )));
      };
  };
  CREATE TYPE default::Author EXTENDING default::User {
      CREATE MULTI LINK fun: default::Author;
      CREATE MULTI LINK follow := (.<fun[IS default::Author]);
  };
  CREATE TYPE default::Comment EXTENDING default::Base {
      CREATE REQUIRED LINK author: default::Author;
      CREATE ACCESS POLICY has_delete
          ALLOW DELETE USING ((((GLOBAL default::current_user_id IN .author.id) ?? false) OR ((GLOBAL default::current_user_id IN (SELECT
              default::Admin.id
          )) ?? false))) {
              SET errmessage := '没有权限删除该评论';
          };
      CREATE LINK recover: default::Comment;
      CREATE REQUIRED PROPERTY text: std::str;
  };
  CREATE SCALAR TYPE default::State EXTENDING enum<NULL, Complie, Full>;
  CREATE TYPE default::Post EXTENDING default::Base {
      CREATE PROPERTY state: default::State {
          SET default := (default::State.Complie);
      };
      CREATE ACCESS POLICY has_insert
          ALLOW INSERT USING (true);
      CREATE REQUIRED PROPERTY body: std::str;
      CREATE PROPERTY post_time: std::datetime {
          CREATE REWRITE
              INSERT 
              USING ((std::datetime_of_statement() IF (__subject__.state ?= default::State.Full) ELSE .post_time));
      };
      CREATE REQUIRED PROPERTY title: std::str;
  };
  ALTER TYPE default::Author {
      CREATE MULTI LINK posts: default::Post {
          ON TARGET DELETE ALLOW;
      };
  };
  ALTER TYPE default::Post {
      CREATE MULTI LINK author := (.<posts[IS default::Author]);
      CREATE ACCESS POLICY has_delete
          ALLOW DELETE USING ((((GLOBAL default::current_user_id IN .author.id) ?? false) OR ((GLOBAL default::current_user_id IN (SELECT
              default::Admin.id
          )) ?? false)));
      CREATE ACCESS POLICY has_hidden
          ALLOW SELECT USING ((((.state != default::State.NULL) ?? false) OR ((GLOBAL default::current_user_id IN .author.id) ?? false)));
      CREATE ACCESS POLICY has_update
          ALLOW UPDATE USING (((GLOBAL default::current_user_id IN .author.id) ?? false));
  };
  CREATE TYPE default::Tag EXTENDING default::Base {
      CREATE MULTI LINK child_tags: default::Tag;
      CREATE LINK paren_tag := (.<child_tags[IS default::Tag]);
      CREATE REQUIRED PROPERTY body: std::str;
  };
  ALTER TYPE default::Post {
      CREATE MULTI LINK tags: default::Tag;
  };
  ALTER TYPE default::Tag {
      CREATE LINK posts := (.<tags[IS default::Post]);
  };
};
