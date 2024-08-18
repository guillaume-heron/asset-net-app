namespace API.Domain;

public sealed class TodoItem
{
    public Guid Id { get; init; }
    public string Title { get; init; }
    public string Description { get; init; }
    public bool IsComplete { get; init; }

    private TodoItem(Guid id, string title, string description, bool isComplete)
    {
        Id = id;
        Title = title;
        Description = description;
        IsComplete = isComplete;
    }

    public static TodoItem Create(string title, string description, bool isComplete)
    {
        return new TodoItem(
            Guid.NewGuid(),
            title,
            description,
            isComplete);
    }
}
