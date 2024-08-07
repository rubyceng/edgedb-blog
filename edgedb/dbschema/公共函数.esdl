# module default{
#     # 查询当前用户拥有的所有博文
#     function getUserPostById(id :str)-> array<Post>
#     using (
#     with 
#     _post := (select Post filter <uuid>id in (.author.id)),
#     select array_agg(_post)
#     )
# }