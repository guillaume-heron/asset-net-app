namespace API.Features.TodoItems;

public static class TodoItemsEndpoints
{
    public static void Register(this IEndpointRouteBuilder app)
    {
        var todoItems = app.MapGroup("todoitems")
            .WithTags("TodoItems")
            .WithOpenApi();

        GetTodoItem.AddEndpoint(todoItems);
        CreateTodoItem.AddEndpoint(todoItems);
    }
}
