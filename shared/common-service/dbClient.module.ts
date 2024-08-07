import { Module } from '@nestjs/common';
import { ClientService } from './dbClient';

@Module({
    providers: [ClientService],
    exports: [ClientService],
})
export class DbModule { }
