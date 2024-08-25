namespace API.Shared.Result;

public sealed record Error(ErrorType Type, string Code, string Description, Dictionary<string, string[]> Failures)
{
    public static readonly Error None = new(ErrorType.None, string.Empty, string.Empty, []);

    public static Error InputValidation(string code, Dictionary<string, string[]> failures)
        => new(ErrorType.Validation, code, "One or more input validation errors occured.", failures);

    public static Error DomainValidation(string code, Dictionary<string, string[]> failures)
        => new(ErrorType.Validation, code, "One or more domain validation errors occured.", failures);

    public static Error NotFound(string code)
        => new(ErrorType.NotFound, code, "The entity with specified Id could not be found.", []);

    public static Error Conflict(string code, string description)
        => new(ErrorType.Conflict, code, description, []);
}
