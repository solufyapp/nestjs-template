import { ConfigifyModule } from "@itgorillaz/configify";
import { Module } from "@nestjs/common";

import * as Clients from "@/clients";
import * as Modules from "@/modules";

@Module({
  imports: [
    ConfigifyModule.forRootAsync(),
    ...Object.values(Clients),
    ...Object.values(Modules),
  ],
})
export class AppModule {}
