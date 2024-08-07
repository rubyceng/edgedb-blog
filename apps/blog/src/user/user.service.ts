import e from 'edgeql-js';
import { ClientService } from 'shared/common-service/dbClient';
import { Injectable } from '@nestjs/common';
import { getAllUser } from './ql/user.ql'
@Injectable()
export class UserService {
    constructor(private readonly dbLClientService: ClientService) { }
    async getAllUser() {
        return getAllUser(this.dbLClientService.client)
        // return this.dbLClientService
    }

}
