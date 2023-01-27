# Coding Guidelines

The coding guidelines in Swift are enforced through clang-tidy. You can either run clang-tidy locally or use the automated CI process that runs in every PR into Swift. CI will provide a git patch with all suggested changes which you can apply locally. After applying the suggested changes please make sure everything still compiles. The fixes done by clang-tidy are not garantueed to work in all cases.

## Type dependent prefixes 

These type dependent prefix is currently only mandatory for member variables. Function / Method parameter names and variables in Function / Method bodies can be named to the programmers liking.

TODO: Add examples of correct TDP

## Members of structs and Classes

### Non-Static

If the member is public, no rules apply.

For private and protected members, the following rules apply:
 * All members must start with 'm_' (this comes before the type dependent prefix)
 * The name of the static member must be in PascalCase: `m_MyMember` 



 ### Static members
If the member is public, no rules apply.

For private and protected members, the following rules apply:
 * If the member is a constant, it should be marked `constexpr`: `static constexpr csInt32 MyConstant = 5;`
 * Otherwise the member must start with 's_' (this comes before the type dependent prefix)
 * The name of the static member must be in PascalCase: `s_MyMember` 
