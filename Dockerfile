# Multi-stage build for RISE .NET 9.0 Application
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /app

# Kopieer solution en alle csproj files voor restore caching
COPY Rise.sln .
COPY src/Rise.Domain/Rise.Domain.csproj src/Rise.Domain/
COPY src/Rise.Shared/Rise.Shared.csproj src/Rise.Shared/
COPY src/Rise.Services/Rise.Services.csproj src/Rise.Services/
COPY src/Rise.Persistence/Rise.Persistence.csproj src/Rise.Persistence/
COPY src/Rise.Client/Rise.Client.csproj src/Rise.Client/
COPY src/Rise.Server/Rise.Server.csproj src/Rise.Server/
COPY tests/Rise.Domain.Tests/Rise.Domain.Tests.csproj tests/Rise.Domain.Tests/
COPY tests/Rise.Services.Tests/Rise.Services.Tests.csproj tests/Rise.Services.Tests/
COPY tests/Rise.Client.Tests/Rise.Client.Tests.csproj tests/Rise.Client.Tests/

RUN dotnet restore Rise.sln

# Kopieer de rest van de broncode en publiceer het Server project
COPY . .
RUN dotnet publish src/Rise.Server/Rise.Server.csproj -c Release -o /app/publish

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .

ENV ASPNETCORE_URLS=http://+:5000
EXPOSE 5000

ENTRYPOINT ["dotnet", "Rise.Server.dll"]