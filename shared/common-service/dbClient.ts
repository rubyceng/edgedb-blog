import { Injectable, } from "@nestjs/common";
import { Client, createClient, Duration, IsolationLevel } from "edgedb";
import { Logger } from "log/Logger";

@Injectable()
export class ClientService {
    client: Client;
    async getConnected(baseClient: Client) {
        return await baseClient.ensureConnected()
    }
    constructor() {
        Logger.error("初始化")
        const baseClient = createClient({
            host: process.env.DB_EDGEDB_HOST,
            port: Number(process.env.DB_EDGEDB_PORT || 5656),
            database: process.env.DB_EDGEDB_BRANCH,
            user: process.env.DB_EDGEDB_USERNAME,
            password: process.env.DB_EDGEDB_PASSWORD,
            // tlsCA:'',
            // secretKey:'',
            // serverSettings:{},
            tlsSecurity: 'insecure',
        })
        Logger.error("数据库连接情况:", this.getConnected(baseClient))
        this.client = baseClient
            .withConfig({
                // 10 seconds
                session_idle_transaction_timeout: Duration.from({ seconds: 10 }),
                // 0 seconds === no timeout
                query_execution_timeout: Duration.from({ seconds: 0 }),
                allow_bare_ddl: "NeverAllow",
                allow_user_specified_id: false,
                apply_access_policies: true,
            })
            .withRetryOptions({
                attempts: 3,
                backoff: (attemptNo: number) => {
                    // exponential backoff
                    return 2 ** attemptNo * 100 + Math.random() * 100;
                },
            })
            .withTransactionOptions({
                isolation: IsolationLevel.Serializable, // only supported value
                deferrable: false,
                readonly: false,
            });
    }
    setGlobals(uid) {
        this.client = this.client.withGlobals({ current_user_id: uid });
        // console.log('sss', this.client);
    }
    setAccessPolicies(bo: boolean) {
        this.client.withConfig({ apply_access_policies: bo });
    }
}