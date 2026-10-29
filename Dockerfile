FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS base
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

# التعديل هنا: بنسخ كل الملفات في الأول عشان الـ Namespaces والـ Project يشوفوا بعض
COPY . .

RUN dotnet restore "MedicalCaravanApp.csproj"
RUN dotnet build "MedicalCaravanApp.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "MedicalCaravanApp.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "MedicalCaravanApp.dll"]
