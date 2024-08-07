import { Body, Controller, Headers, Get } from '@nestjs/common';
import { UserService } from './user.service';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
@ApiTags('用户相关')
@Controller('user')
export class UserController {
    constructor(private readonly userService: UserService) { }

    @ApiOperation({ summary: '字典单据创建' })
    @Get()
    async createDoc(@Headers() headers) {
        return this.userService.getAllUser();
    }


}
