CREATE MIGRATION m1dmalcaqj4gmicsc3akivublrwddd7e7j7sp5oo76v2qfwf3nbuaa
    ONTO m1uhdwa5aifdlwhecdobl2ytes3pu3jew5zwnmozyo6qqlfutuaogq
{
  ALTER TYPE default::Post {
      ALTER ACCESS POLICY has_hidden USING (((.state ?= default::State.Full) OR ((GLOBAL default::current_user_id IN .author.id) ?? false)));
  };
};
