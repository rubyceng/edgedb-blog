CREATE MIGRATION m13zpy7qfw4rokeaelhvcfom2yh5ngcvpzraxykm4gxoxkjbgcw7pa
    ONTO m1pxpbzse4urkmcsauiyd25ikhnumz6uouo4kkiy3wifgbgirozj6a
{
  CREATE SCALAR TYPE default::country EXTENDING enum<China, Other>;
};
