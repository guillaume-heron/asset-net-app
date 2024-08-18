using API.Domain;

public static class GetTodoItem
{
    internal static async Task<TodoItem> Handle(Guid id)
    {
        await Task.Delay(1000);

        return TodoItem.Create(
            "Complete .Net asset application",
            "Complete a sample application, that shows how to build and deploy infrastructure and" +
            " a containerized .Net web api in an Azure app Service via Terraform and Github Actions.",
            false);
    }

    public static void AddEndpoint(this RouteGroupBuilder group)
    {
        group.MapGet("{id}", async (Guid id) =>
        {
            var todoItem = await Handle(id);

            return Results.Ok(todoItem);
        })
        .Produces(StatusCodes.Status200OK);
    }
}
