import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { UserModule } from './user/user.module';
import ConfigOptions from 'shared/config/config.nest';
@Module({
  imports: [ConfigModule.forRoot(ConfigOptions), UserModule],
})
export class BlogModule { }
