const ConfigOptions = {
    envFilePath: ['apps/blog/.env', 'apps/blog/.env.' + process.env.NODE_ENV],
    isGlobal: true,
}
export default ConfigOptions;