using FluentValidation.Results;

namespace API.Shared.Extensions;

public static class ValidationFailureExtensions
{
    public static Dictionary<string, string[]> ToDictionary(this List<ValidationFailure> failures)
    {
        return failures.ToDictionary(
            x => x.PropertyName,
            x => new string[] { x.ErrorMessage });
    }
}
