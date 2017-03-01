defmodule BlogSearch do
  @moduledoc """
  Documentation for BlogSearch.
  """

  @doc """

  """
  def normalize(tokens) when is_list(tokens) do
    Enum.map(tokens, fn s -> normalize(s) end)
  end
  def normalize(token) do
    String.downcase(token)
  end

  def calculate_tfs(text) do
    normalize(text) |>
    Enum.reduce(Map.new, fn t, acc -> Map.update(acc, t, 1, &(&1 + 1)) end)
  end

  def is_present?(texts, term) do
    Enum.member?(texts, term)
  end

  def calculate_idfs(corpus, terms) do
    num_of_docs = length(corpus)
    corpus = Enum.map(corpus, fn s -> normalize(s) end)
    terms = normalize(terms)
    for term <- terms, into: %{} do
      docs_having_term = Enum.filter(corpus, fn s -> is_present?(s, term) end)
      {term, :math.log(num_of_docs/length(docs_having_term))}
    end
  end

  def calculate_tfidf(corpus) do
    tfs = Enum.map(corpus, fn texts -> calculate_tfs(texts) end)
    terms = Enum.map(tfs, fn tf -> Map.keys(tf) end) |>
                List.flatten |>
                  Enum.uniq
    idfs = calculate_idfs(corpus, terms)
    Enum.map(tfs, fn tf -> (for {term, value} <- tf, into: %{}, do: {term, value * idfs[term]}) end)
  end

  def create_index(corpus) do
    tf_idf = calculate_tfidf(corpus)
    Enum.with_index(tf_idf) |>
      Enum.reduce(Map.new,
        fn {t, index}, acc ->
          result = (for {term, value} <- t, into: %{} do
           tfidf_map = Map.get(acc, term, %{})
           {term, Map.put(tfidf_map, index, value)}
          end
          )
          Map.merge(acc, result)
        end)
  end

end
