import { Client } from "edgedb"
import e from "edgeql-js"

export const getAllUser = (tx: Client) => {
    const query = e.select(e.Author, () => ({
        ...e.Author['*']
    }))
    return query.run(tx)
}