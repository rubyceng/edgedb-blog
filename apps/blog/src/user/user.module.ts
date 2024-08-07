import { Module } from '@nestjs/common';
import { UserController } from './user.controller';
import { UserService } from './user.service';
import { DbModule } from 'shared/common-service/dbClient.module';
@Module({
    controllers: [UserController],
    imports: [DbModule],
    providers: [UserService]
})
export class UserModule { }
