import e from "edgeql-js"

export const getAllUser = (tx) => {
    const query = e.select(e.User)
    return query.run(tx)
}