CREATE MIGRATION m1uhdwa5aifdlwhecdobl2ytes3pu3jew5zwnmozyo6qqlfutuaogq
    ONTO m1bbscrio4nsgcldr4whwa3utzl7w4h7vdak5jo46aw67lmadwhdmq
{
  ALTER TYPE default::Post {
      ALTER LINK author {
          SET TYPE default::User;
      };
  };
};
