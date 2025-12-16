import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class AppService {
  constructor(private configService: ConfigService) {}

  getHello(): string {
    const environment = this.configService.get<string>('ENVIROMENT', 'development');
    return `Ambiente ${environment} - Control de trafico activado`;
  }
}
