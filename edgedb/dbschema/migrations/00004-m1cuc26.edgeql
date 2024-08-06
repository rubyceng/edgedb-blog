CREATE MIGRATION m1cuc26eulzrbpyqs37mhaebqzwhw25a77uwnk6w4mdzrouswb2i3a
    ONTO m13zpy7qfw4rokeaelhvcfom2yh5ngcvpzraxykm4gxoxkjbgcw7pa
{
  ALTER TYPE default::Post {
      ALTER LINK author {
          RESET EXPRESSION;
          RESET EXPRESSION;
          RESET OPTIONALITY;
          SET TYPE default::Author;
      };
  };
  ALTER TYPE default::Author {
      ALTER LINK posts {
          USING (.<author[IS default::Post]);
          RESET ON TARGET DELETE;
      };
  };
  DROP SCALAR TYPE default::country;
};
