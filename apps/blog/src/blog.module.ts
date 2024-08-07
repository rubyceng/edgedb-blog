import { Module } from '@nestjs/common';
import { BlogService } from './blog.service';
import { ConfigModule } from '@nestjs/config';
import { UserModule } from './user/user.module';
import ConfigOptions from 'shared/config/config.nest';
@Module({
  imports: [ConfigModule.forRoot(ConfigOptions), UserModule],
  providers: [BlogService],
})
export class BlogModule { }
