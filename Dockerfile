FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["MedicalCaravanApp.csproj", "./"]
RUN dotnet restore "MedicalCaravanApp.csproj"
COPY . .
RUN dotnet build "MedicalCaravanApp.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "MedicalCaravanApp.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "MedicalCaravanApp.dll"]